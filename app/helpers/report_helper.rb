module ReportHelper
    def chart_tag (action, height, params = {})
        params[:format] ||= :json
        path = url_for(:action => action, :controller => 'report', :format => 'json', :params => params)
        content_tag(:div, :'data-chart' => path, :style => "height: #{height}px;") do
            image_tag('spin.gif', :size => '24x24', :class => 'spinner')
        end
    end
end
