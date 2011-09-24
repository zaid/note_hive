Factory.define :user do |user|
  user.name                  'Test User'
  user.email                 'user@example.ca'
  user.password              'foobar'
  user.password_confirmation 'foobar'
end

Factory.sequence :email do |n|
  "user-#{n}@example.ca"
end

Factory.define :notebook do |notebook|
  notebook.title            'Foo bar'
  notebook.association      :user
end

Factory.define :note do |note|
  note.content              'Foo bar'
  note.association          :user
  note.association          :notebook
end
