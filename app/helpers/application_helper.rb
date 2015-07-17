module ApplicationHelper
  def customers_icon
    content_tag("i", "", class: "fa fa-users")
  end

  def orders_icon
    content_tag("i", "", class: "fa fa-truck")
  end

  def menu_items_icon
    content_tag("i", "", class: "fa fa-book")
  end
end
