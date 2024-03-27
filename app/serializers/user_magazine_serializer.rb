class UserMagazineSerializer < ActiveModel::Serializer
  attributes :id, :title, :publisher, :genre
end