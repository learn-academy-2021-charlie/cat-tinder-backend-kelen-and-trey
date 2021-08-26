require 'rails_helper'

RSpec.describe "Cats", type: :request do
  let (:cat_1){
    Cat.create!({
      name: "Mittens",
      age: 5,
      enjoys: "sunshine and warm spots"
    })
  }
  let (:cat_2){
    Cat.create!({
      name: "Raisins",
      age: 4,
      enjoys: "being queen of the dogs"
    })
  }
  let (:cat_3){
    Cat.create!({
      name: "Toast",
      age: 1,
      enjoys: "getting all the attention"
    })
  }

  before do
    cat_1
    cat_2
    cat_3
  end

  describe "GET /index" do
    it 'gets a list of cats' do
      get "/cats"
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).length).to eq 3
    end
  end

  describe "POST /create" do
    let (:request) {
      post "/cats", params: {
        cat: {
          name: "fluffy butters",
          age: 190,
          enjoys: "biting you after belly rubs"
        }
      }
    }
    it "should create a new cat" do
      expect{request}.to change{Cat.count}.by 1
      expect(response.status).to eq 200
      new_cat = Cat.last
      expect(new_cat.name).to eq "fluffy butters"
      expect(new_cat.age).to eq 190
      expect(new_cat.enjoys).to eq "biting you after belly rubs"
    end
  end

  describe 'PATCH /update' do
    let (:request) {
      patch "/cats/#{cat_1.id}", params: {
        cat: {
          name: "Fluffy B. Starfish"
        }
      }
    }
    it 'updates the name of the first cat in the database' do
      request
      expect(Cat.first.name).to eq 'Fluffy B. Starfish'
      expect(response.status).to eq 200
    end
  end

  describe 'DELETE /destroy' do
    let (:request) {
      delete "/cats/#{cat_1.id}"
    }
    it 'deletes cat_1' do
      expect{request}.to change {Cat.count}.by -1
      expect(response.status).to eq 200
    end
  end

  describe 'request validations' do
    it 'throws an error with empty name' do
      request = {
        cat: {
          name: '',
          age: 5,
          enjoys: 'valid strings'
        }
      }
      post '/cats', params: request
      expect(response.status).to eq 422
    end
    it 'throws error with empty age' do
      request = {
        cat: {
          name: 'valid string',
          age: '',
          enjoys: 'valid strings'
        }
      }
      post '/cats', params: request
      expect(response.status).to eq 422
    end
    it 'throws error with empty enjoys' do
      request = {
        cat: {
          name: 'valid string',
          age: 10,
          enjoys: ''
        }
      }
      post '/cats', params: request
      expect(response.status).to eq 422
    end
    it 'throws error for enjoys with length less than 10' do
      request = {
        cat: {
          name: 'valid name',
          age: 10,
          enjoys: 'four'
        }
      }
      post '/cats', params: request
      expect(response.status).to eq 422
    end
  end
end
