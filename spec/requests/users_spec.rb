require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user) { create(:user) }

  describe 'UPDATE #update' do
    before do
      patch game_cell_path(game, cell)
    end

    it 'should update cells' do
      expect(response).to have_http_status 302
      expect(response).to redirect_to(game)
    end
  end

  describe 'FLAG #flag' do
    before do
      patch flag_game_cell_path(game, cell)
    end

    it 'should flag cells' do
      expect(response).to have_http_status 302
      expect(response).to redirect_to(game)
    end
  end
end

