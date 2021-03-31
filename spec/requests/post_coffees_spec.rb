require 'rails_helper'

describe 'post a coffee route', :type => :request do

  let!(:user) {FactoryBot.create(:user)}

  context 'when successful' do
    before do
      post api_v1_coffees_path,
        params: { blend_name: 'Test Blend', origin: 'Test Origin', notes: 'Mmm, mmm, good'},
        headers: { "X-Api-Key" => user.api_key }
      @response = JSON.parse(response.body)["coffee"]
    end

    it 'returns the blend name' do
      expect(@response['blend_name']).to eq('Test Blend')
    end

    it 'returns the origin' do
      expect(@response['origin']).to eq('Test Origin')
    end

    it 'returns the notes' do
      expect(@response['notes']).to eq('Mmm, mmm, good')
    end

    it 'returns a created status' do
      expect(response).to have_http_status(201)
    end
  end

  context 'when not successful' do
    before do
      post api_v1_coffees_path,
        params: { blend_name: '', origin: 'Test Origin', notes: 'Mmm, mmm, good'},
        headers: { "X-Api-Key" => user.api_key }
    end
    it 'returns an unprocessable entity status' do
      expect(response).to have_http_status(422)
    end
  end
end
