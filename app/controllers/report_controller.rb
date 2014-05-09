class ReportController < ApplicationController
    def index
    end

    def submissions
    end

    def comments
    end

    def submissions_graph
        @days = (params[:days] || 7).to_i
        render :json => {
            :type => 'AreaChart',
            :cols => [['string', 'Date'], ['number', 'Submitted'], ['number', 'Completed'],['number', 'Comments']],
            :rows => (0..@days).to_a.inject([]) do |memo, i|
            date = i.days.ago.to_date
            t0, t1 = date.beginning_of_day, date.end_of_day

            if params[:user] == '0'
                @all = Ticket
                @comments = Comment
            else
                @all = Ticket.where(:submitter_id => params[:user])
                @comments = Comment.where(:user_id => params[:user])
            end
            if params[:building] == '0' || !params[:building]
                tickets = @all.where('created_at >= ? AND created_at <= ?', t0, t1).count
                completed = @all.where(:status => 100).where('updated_at >= ? AND updated_at <= ?', t0, t1).count
                comments = @comments.where('created_at >= ? AND created_at <= ?', t0, t1).count - tickets
                comments = 0 if comments < 0
            else
                building = Building.find(params[:building])
                tickets = @all.where(:room_id => building.room_ids).where('created_at >= ? AND created_at <= ?', t0, t1)
                completed = @all.where(:room_id => building.room_ids, :status => 100).where('updated_at >= ? AND updated_at <= ?', t0, t1).count
                comments = @comments.where('created_at >= ? AND created_at <= ?', t0, t1).where(:ticket_id => tickets.map{|t| t.id}).count - tickets.count
                tickets = tickets.count
                comments = 0 if comments < 0
            end
            memo << [date, tickets, completed, comments]
            end.reverse,
                :options => {
                :chartArea => {:width => '90%', :height => '75%'},
                :hAxis => {:showTextEvery => 2},
                :legend => 'bottom',
                :title => 'Tickets Submitted by Day'
            }
        }
    end

    def comments_graph
        @days = (params[:days] || 7).to_i
        render :json => {
            :type => 'AreaChart',
            :cols => [['string', 'Date'], ['number', 'Comments']],
            :rows => (0..@days).to_a.inject([]) do |memo, i|
            date = i.days.ago.to_date
            t0, t1 = date.beginning_of_day, date.end_of_day

            if params[:user] == '0'
                @all = Comment
            else
                @all = Comment.where(:user_id => params[:user])
            end
            comments = @all.where('created_at >= ? AND created_at <= ?', t0, t1).count
            memo << [date, comments]
            end.reverse,
                :options => {
                :chartArea => {:width => '90%', :height => '75%'},
                :hAxis => {:showTextEvery => 2},
                :legend => 'bottom',
                :title => 'Comments by Day'
            }
        }
    end
end
