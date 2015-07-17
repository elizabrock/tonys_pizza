class MenuItem < ApplicationRecord
  validates_numericality_of :price, allow_blank: true, message: "must be a number"
  validates_presence_of :name, :price

  def image=(image_file)
    if image_file.respond_to?(:original_filename)
      image_name = image_file.original_filename
    else
      image_name = File.basename(image_file.path)
    end
    # This is the path that we save to the database so that we can create links
    # to this image in the future
    url_path = File.join('uploads', image_name)
    # This is where we save the actual image on the filesystem.
    # Rails will look in /public/uploads/foo.jpg to find /uploads/foo.jpg
    file_path = Rails.root.join('public', url_path)
    super(url_path)
    File.open(file_path, 'wb') do |file|
      file.write(image_file.read)
    end
  end

  def image_path
    if self.image.present?
      File::SEPARATOR + self.image
    else
      "/assets/placeholder_menu_item.jpg"
    end
  end

  def image_location
    return if self.image.blank?
    Rails.root.join('public', self.image)
  end
end
