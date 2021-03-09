require 'rails_helper'

describe Movie do
    describe '.find_same_director' do #.find_same_director needs to have psuedo data
        let!(:m1) { FactoryBot.create(:movie, title: 'Movie1', director: 'Director1') }
        let!(:m2) { FactoryBot.create(:movie, title: 'Movie2', director: 'Director2') }
        let!(:m3) { FactoryBot.create(:movie, title: 'Movie3', director: 'Director1') }
        let!(:m4) { FactoryBot.create(:movie, title: 'Movie4') }
    
        context 'director exists' do
            it 'finds movies with same director correctly' do
                expect(Movie.find_same_director(m1)).to eq([m1, m3])
                expect(Movie.find_same_director(m2)).to eq([m2])
            end
        end
        
        context 'director does not exist' do
            it 'returns nil (sad path handled in controller)' do
                expect(Movie.find_same_director(m4)).to eq(nil)
            end
        end
    end
end