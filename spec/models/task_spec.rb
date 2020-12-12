require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end
    it 'is invalid without title' do
      task_without_title = build(:task, title: '')
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end
    it 'is invalid without status' do
      task_without_status = build(:task, status: '')
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end
    it 'is invalid with a duplicate title' do
      task = create(:task)
      another_task = build(:task, title: task.title)
      expect(another_task).to be_invalid
      expect(another_task.errors[:title]).to include("has already been taken")
    end
    it 'is valid with another title' do
      task = create(:task)
      another_task = build(:task, title: 'titl_2')
      expect(another_task).to be_valid
      expect(another_task.errors).to be_empty
    end
  end
end
