class UserBookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :genre
end