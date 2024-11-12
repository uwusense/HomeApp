module IconHelper
  def ic_icon(icon_name, options={})
    css_class = ["icon icon-#{icon_name}"]
    css_class << options[:class]

    content_tag(:i, nil, class: css_class.compact.join(' '), title: options[:title], data: options[:data])
  end
end
