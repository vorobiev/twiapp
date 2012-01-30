# encoding: UTF-8

require 'csv'
require 'iconv'

class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
    @queries = @task.queries
    
          
    if params[:tweet].nil?
      @date_to = Time.now
      @date_from = Time.now - 3.days
    else
      @date_to = Date.civil(params[:tweet][:"date_to(1i)"].to_i,params[:tweet][:"date_to(2i)"].to_i,params[:tweet][:"date_to(3i)"].to_i) 
      @date_from = Date.civil(params[:tweet][:"date_from(1i)"].to_i,params[:tweet][:"date_from(2i)"].to_i,params[:tweet][:"date_from(3i)"].to_i) unless params[:tweet].nil?
    
    end
    
    
    
    @tweets = Tweet.where(:query_id => @queries, :date => @date_from..@date_to ).order('date DESC')
  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
      format.xls do
        
        tmp = Tempfile.new('writeexcel')
        workbook = WriteExcel.new(tmp.path)
      
        worksheet  = workbook.add_worksheet
        
        # Add and define a format
        format = workbook.add_format
        format.set_bold
        
        # write a formatted and unformatted string.
        worksheet.write(0, 0, 'Дата')  # cell B2
        worksheet.write(0, 1, 'Время') 
        worksheet.write(0, 2, 'Автор')   
        worksheet.write(0, 3, 'Ссылка на автора')
        worksheet.write(0, 4, 'Текст')          # cell B3
        worksheet.write(0, 5, 'Ссылка на твит')   
        
        counter = 1
        
        @tweets.each do |tweet|
          
          worksheet.write(counter, 0, l( tweet.date , :format => '%d.%m.%Y' ))
          worksheet.write(counter, 1, l( tweet.date , :format => '%H:%M' )) 
          worksheet.write(counter, 2, tweet.user ) 
          worksheet.write(counter, 3, 'http://twitter.com/' + tweet.user )
          worksheet.write(counter, 4, tweet.text )
          worksheet.write(counter, 5, 'http://twitter.com/' + tweet.user + '/status/' + tweet.tweet_id )
                  
          counter += 1

        end
        
        
        # write to file
        workbook.close
        
        
        file = tmp.read
        
        send_data file,
            :type => 'application/vnd.ms-excel',
            :disposition => "attachment; filename=tweets-from-" + @date_from.strftime('%d-%m') + '-to-'  + @date_to.strftime('%d-%m') + "-generated-" + Time.now.strftime('%d-%m-at-%H:%M') + ".xls"
        
        
      end
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :ok }
    end
  end
end
