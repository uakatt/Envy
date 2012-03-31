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

  def java_memory_used_with_updated_at_title(environment_id)
    latest_melodie_snapshots = Environment.find(environment_id).latest_melodie_snapshots
    return content_tag(:span, "no melodie snapshots", :class => 'tiny-error') if latest_melodie_snapshots.nil?

    results = []
    latest_melodie_snapshots.each do |snapshot|
      result = ''
      if snapshot.snapshot_errors
        text = "Melodie Error: " + snapshot.snapshot_errors.to_s
        result += content_tag(:span, text, :class => 'tiny-error')
        results << result
        next
      end

      system_information = snapshot.system_information
      if system_information.nil?
        text = "No System Information..."
        result += content_tag(:span, text, :class => 'tiny-error')
        results << result
        next
      end

      text = system_information[:java_memory_used].join(' out of ')

      if snapshot.taken_at
        result += content_tag :span, text, :title => "Taken at: #{snapshot.taken_at.localtime}"
      else
        result += text
      end
      results << result
    end
    results.each(&:html_safe).join('<br />').html_safe
  end

  def latest_melodie_stat_or_error(environment, *chain)
    latest_melodie_snapshot = environment.latest_melodie_snapshot
    return content_tag(:span, "no melodie snapshots", :class => 'tiny-error') if latest_melodie_snapshot.nil?

    if latest_melodie_snapshot.snapshot_errors
      text = "Melodie Error: " + latest_melodie_snapshot.snapshot_errors.to_s
      return content_tag(:span, text, :class => 'tiny-error')
    end

    stat = latest_melodie_snapshot
    until chain.empty?
      stat_name = chain.shift
      case
      when stat.is_a?(Hash) then stat = stat[stat_name]
      else                       stat = stat.send(stat_name)
      end
      return "#{stat_name} is empty for the latest snapshot" if stat.nil?
    end
    return stat
  end

  def titlize_parens(value)
    if value =~ /^(.+?) \((.+)\)$/
      content_tag :span, $1, :title => $2
    else
      value
    end
  end
end
