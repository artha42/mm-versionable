MongoMapper.database = YAML.load(File.read('config/database.yml'))[ENV['RACK_ENV']]['database'] rescue 'versionable_test'
