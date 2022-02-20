require 'rails_helper'

RSpec.describe TimesheetsController, type: :controller do
  describe '#new' do
    it 'creates a new Timesheet' do
      expect(Timesheet).to receive(:new)
      get :new
    end

    it 'renders the new Timesheet template' do
      get :new
      expect(response).to render_template(:new)
    end
  end
end
