require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe MediaOrganiser::Data do
  before(:all) do
    @files = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures.yml')))
  end

  it 'finds the movie/show title from a file name' do
    @files.each do |file|
      MediaOrganiser::Data.get_title(file['original']).to_s.should == file['title'].to_s
    end
  end

  it 'finds the resolution from the file name' do
    @files.each do |file|
      MediaOrganiser::Data.get_resolution(file['original']).to_s.should == file['resolution'].to_s if file.key?('resolution')
    end
  end

  it 'finds the cd number from a movie file name' do
    @files.each do |file|
      MediaOrganiser::Data.get_cd(file['original']).to_s.should == file['cd'].to_s if file.key?('cd')
    end
  end

  it 'finds the year from a movie file name' do
    @files.each do |file|
      MediaOrganiser::Data.get_year(file['original']).to_s.should == file['year'].to_s if file.key?('year')
    end
  end

  it 'finds the tv show season from an episode file name' do
    @files.each do |file|
      MediaOrganiser::Data.get_season(file['original']).to_s.should == file['season'].to_s.rjust(2, '0') if file.key?('season')
    end
  end

  it 'finds the tv show episode number from an episode file name' do
    @files.each do |file|
      MediaOrganiser::Data.get_episode(file['original']).to_s.should == file['episode'].to_s.rjust(2, '0') if file.key?('episode')
    end
  end
end
