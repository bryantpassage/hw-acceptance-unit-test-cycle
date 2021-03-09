require 'rails_helper'

describe MoviesController do
    describe 'Search movies by the same director' do
        it 'should call Movie.find_same_director' do
            expect(Movie).to receive(:find_same_director).with(Movie)
            get :search, { id: '1' }
            
        end
        
        it 'should show similar movies if director exists' do 
            Movie.create({title: 'Jurassic Park', rating: 'PG-13', release_date: '11-Jun-1993', director: 'Steven Spielberg'}) #create movie with Steven Spielberg as director
            ret_movies = ['Raiders of the Lost Ark', 'Jurassic Park']
            Movie.stub(:find_same_director).with(Movie.find(9)).and_return(ret_movies)        #mock method that returns array of movies
            get :search, {id: '9'}
            expect(assigns(:movies)).to eq(ret_movies)
        end
        
        it 'should redirect to home page if director isn\'t known and show flash message' do
            Movie.create({title: 'No Name', rating: 'PG-13', release_date: '11-Jun-1993'}) #create movie with unknown directorr
            Movie.stub(:find_same_director).with(Movie.find(11)).and_return(nil)
            get :search, {id: '11'}
            expect(response).to redirect_to(movies_path(back:1))                                #expect redirection to home page
            expect(flash[:notice]).to eq("'No Name' has no director information")       #expect a response from flash
        end
    end
end