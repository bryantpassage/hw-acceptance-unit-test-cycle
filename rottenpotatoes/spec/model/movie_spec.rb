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
    
    describe '.all_ratings' do
        it 'should return all ratings' do
            expect(Movie.all_ratings()).to eq(['G', 'PG', 'PG-13', 'R'])
        end
    end
    
    describe '.with_ratings' do
        let!(:m1) { FactoryBot.create(:movie, title: 'Movie1', director: 'Director1', rating: 'X') }
        let!(:m2) { FactoryBot.create(:movie, title: 'Movie2', director: 'Director2', rating: 'Y') }
        
        context  'if ratings list is empty' do
            it 'calls .all' do
                expect(Movie).to receive(:all)
                Movie.with_ratings([])
            end
        end
        
        context 'if ratings list is not empty' do
            it 'returns movie list with ratings specific to the movie' do
                expect(Movie.with_ratings(['X'])).to eq([m1])
            end
        end
    end
    
    describe '.get_movies' do
        context 'if ratings list is empty and sort is not nil' do
            it 'should call .where with certain parameters' do
                expect(Movie).to receive(:order).with('title')
                Movie.get_movies('title', [])
            end
        end
    end
                
end