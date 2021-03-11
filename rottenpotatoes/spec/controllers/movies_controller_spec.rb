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
    
    describe 'create movie' do
        it 'should assign movie to @movie' do
            post :create, movie: {title: 'New movie', rating: 'X', description: 'no description', release_date: '19-Nov-1999', director: 'Bryant Passage'}
            expect(assigns(:movie).title).to include('New movie')
        end
        
        it 'redirects to homepage' do
            post :create, movie: {title: 'New movie', rating: 'X', description: 'no description', release_date: '19-Nov-1999', director: 'Bryant Passage'}
            expect(response).to redirect_to(movies_path)
            expect(flash[:notice]).to eq("New movie was successfully created.")
        end
    end
    
    describe 'show movie with id param' do
        it 'should assign movie to @movie' do
            get :show, {id: 1}
            expect(assigns(:movie).title).to include('Aladdin')
        end
    end
    
    describe 'edit movie with id param' do
        it 'should assign @movie with movie instance' do
            get :edit, {id: 1}
            expect(assigns(:movie).title).to include('Aladdin')
        end
    end
    
    describe 'update movie with id param' do
        it 'should assign @movie with movie instance' do
            put :update, id: 1, movie: {title: 'New movie', rating: 'X', description: 'no description', release_date: '19-Nov-1999', director: 'Bryant Passage'}
            expect(assigns(:movie).title).to include('New movie')
        end
    
        
        it 'redirects to movie page' do
            put :update, id: 1, movie: {title: 'New movie', rating: 'X', description: 'no description', release_date: '19-Nov-1999', director: 'Bryant Passage'}
            expect(response).to redirect_to(movie_path(id: 1))
            expect(flash[:notice]).to eq("New movie was successfully updated.")
        end
    end
    
    describe 'destroy movie with id param' do
        it 'should assign @movie with movie instance' do
            delete :destroy, id:1
            expect(assigns(:movie).title).to include('Aladdin')
        end
        
        it 'should redirect to homepage' do
            delete :destroy, id:1
            expect(response).to redirect_to(movies_path)
            expect(flash[:notice]).to eq("Movie 'Aladdin' deleted.")
        end
    end
    
    describe 'show index of movies' do
        it 'should call all_ratings' do
            expect(Movie).to receive(:all_ratings)
            get :index
        end
        
        it 'should call get_movies' do
            expect(Movie).to receive(:get_movies)
            get :index
        end
    end
end