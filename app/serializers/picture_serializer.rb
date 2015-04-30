class PictureSerializer < ActiveModel::Serializer
  attributes :title, :image_id, :_self, :image

  def image
    {
      url: Refile.attachment_url(object, :image, format: "jpg")
    }
  end

  def _self
    href = URI::encode("/api/v1/pictures/#{object.id}")
    {
      href: href,
      method: "GET",
      rel: "self"
    }
  end


end
