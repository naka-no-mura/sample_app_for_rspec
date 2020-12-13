require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    context 'タスクの新規作成' do
      it 'タスクの新規作成ページに遷移できないこと' do
        visit new_task_path
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end

    context 'タスクの編集' do
      it 'タスクの編集ページに遷移できないこと' do
        visit edit_task_path(task)
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end

    pending context 'タスク一覧' do
      it 'タスク一覧ページに遷移できること' do
        visit tasks_path
        expect(page).to have_link 'Show'
        expect(current_path).to eq tasks_path
      end
    end

    context 'タスクの詳細' do
      it 'タスクの詳細ページに遷移できること' do
        visit task_path(task)
        expect(page).to have_content task.title
        expect(page).to have_content 'テスト内容'
        expect(current_path).to eq task_path(task)
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }

    describe 'タスクの新規登録' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規登録が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'new_title'
          fill_in 'Content', with: 'テスト内容'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'new_title'
          expect(page).to have_content 'テスト内容'
          expect(page).to have_content 'todo'
          expect(current_path).to eq '/tasks/1'
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'テスト内容'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end
      context '登録済のタイトルを使用' do
        it 'タスクの新規作成が失敗する' do
          other_task = create(:task)
          visit new_task_path
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'テスト内容'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'update_title'
          click_button 'Update Task'
          expect(page).to have_content 'Task was successfully updated.'
          expect(page).to have_content 'update_title'
          expect(current_path).to eq task_path(task)
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: ''
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end
      context '登録済のタイトルを使用' do
        it 'タスクの編集が失敗する' do
          other_task = create(:task, title: 'other_title')
          visit edit_task_path(task)
          fill_in 'Title', with: other_task.title
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスクの削除' do
      context 'タスクの削除' do
        let!(:task) { create(:task, user: user) }

        it 'タスクの削除が成功する' do
          visit tasks_path
          click_link 'Destroy'
          expect {
            page.accept_confirm "Are you sure?"
            expect(page).to have_content "Task was successfully destroyed."
          }.to change { Task.count }.by(-1)
          expect(current_path).to eq tasks_path
        end
      end
    end
  end
end
