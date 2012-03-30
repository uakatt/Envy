module EnvironmentsHelper
  def boolean_symbol(value)
    result = ""
    if value =~ /^(yes|true|y)( .+)?/
      result += "<span style='color: green;' title='#{$1}'>&#x2713;</span>"
      result += content_tag :span, $2
      result.html_safe
    elsif value =~ /^(no|false|n)( .+)?/
      result += "<span style='color: red;' title='#{$1}'>&mdash;</span>"
      result += content_tag :span, $2
      result.html_safe
    end
  end

  def titlize_parens(value)
    if value =~ /^(.+?) \((.+)\)$/
      content_tag :span, $1, :title => $2
    else
      value
    end
  end
end
