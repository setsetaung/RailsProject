class ChannelController < ApplicationController
  #KMMG 2.7.2019
  def new
    @mchannel = MChannel.new   
  end

    def chchannel
     
    end
    def createchannel
      @mchannel = MChannel.new(channel_params)
      puts @mchannel
      #@mchannel.channel_status = params[:session][:status]
      @mchannel.user_id = session[:muser_id]
      puts @mchannel.user_id
      @mchannel.workspace_id = session[:workspace_id]
      puts @mchannel.workspace_id
      if @mchannel.save
        
        session[:channel_name] = @mchannel.channel_name
        mchannel = MChannel.find_by(channel_name: session[:channel_name])
        save mchannel
        puts "session channel"
        puts session[:channel_id]
        puts session[:channel_name]
        redirect_to home_path
      else
        redirect_to login_path
      end 
    end
    private
    def channel_params
      params.require(:mchannel).permit(:channel_name,:status)
    end
  end
    
  

 


  
  
