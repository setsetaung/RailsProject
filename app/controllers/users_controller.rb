class UsersController < ApplicationController
   
    def new
        
    end

    def create
    end

    def login
    end

    def home
        list
    end
    
    #chonweaung
    def channel_chat
        
        channelchat = MChannel.find_by(id:params[:channel_id])
        channel channelchat
        @channel_msg_read = TChannelMsg.select("m_users.user_name,t_channel_msgs.channel_msg,t_channel_msgs.created_at").
                    joins("join m_users on t_channel_msgs.sender_id = m_users.id").
                    joins("join t_channel_unread_msgs on t_channel_msgs.id = t_channel_unread_msgs.channel_msg_id ").
                    where("t_channel_unread_msgs.unread = 0 and t_channel_msgs.channel_id = ?
                    and t_channel_unread_msgs.unread_user_id = ?", session[:channel_id], session[:muser_id])

        @channel_msg_unread = TChannelMsg.select("m_users.user_name,t_channel_msgs.channel_msg,t_channel_msgs.created_at").
                    joins("join m_users on t_channel_msgs.sender_id = m_users.id").
                    joins("join t_channel_unread_msgs on t_channel_msgs.id = t_channel_unread_msgs.channel_msg_id ").
                    where("t_channel_unread_msgs.unread = 1 and t_channel_msgs.channel_id = ?
                    and t_channel_unread_msgs.unread_user_id = ?", session[:channel_id], session[:muser_id])
        
        TChannelUnreadMsg.where(:unread_user_id=>session[:muser_id]).update_all(:unread=>0)


        list
    end

    def msgsend
        
        @channel_msg = TChannelMsg.new
        @channel_msg.channel_id = session[:channel_id]
        @channel_msg.sender_id = session[:muser_id]
        @channel_msg.channel_msg = params[:tchamsg][:msg]
        @channel_msg.save
        last_id = TChannelMsg.maximum("id")
        channel_memberlist
        @member_list.each do |memberlist|
            @channel_unread = TChannelUnreadMsg.new
            @channel_unread.channel_msg_id = last_id
            @channel_unread.unread_user_id = memberlist.userid
            @channel_unread.unread = 1
            @channel_unread.save
        end
        puts "last id"
        puts last_id
    end

    #dirmsg
    def dirchat
        diruser= MUser.find_by(id:params[:id])
        dir diruser
        @dir_msg_read = TDirectMsg.select("sender.user_name as s, receiver.user_name as r, t_direct_msgs.message, t_direct_msgs.created_at").
                    joins("join m_users as sender on t_direct_msgs.sender_id = sender.id").
                    joins("join m_users as receiver on t_direct_msgs.receiver_id = receiver.id ").
                    where("t_direct_msgs.unread=0 and (t_direct_msgs.sender_id = ?
                    and t_direct_msgs.receiver_id = ?
                    or t_direct_msgs.sender_id = ?
                    and t_direct_msgs.receiver_id = ?)
                    and t_direct_msgs.workspace_id = ?",
                     session[:diruser_id], session[:muser_id], session[:muser_id], session[:diruser_id], session[:workspace_id])
        
        @dir_msg_unread = TDirectMsg.select("m_users.user_name, t_direct_msgs.message, t_direct_msgs.created_at").
                     joins("join m_users on t_direct_msgs.sender_id = m_users.id").
                     where("t_direct_msgs.unread=1 and t_direct_msgs.sender_id = ?
                     and t_direct_msgs.receiver_id = ?
                     and t_direct_msgs.workspace_id = ?",
                      session[:diruser_id], session[:muser_id], session[:workspace_id])

        @dir_msg_sent = TDirectMsg.select("m_users.user_name, t_direct_msgs.message, t_direct_msgs.created_at").
                      joins("join m_users on t_direct_msgs.sender_id = m_users.id").
                      where("t_direct_msgs.unread=1 and t_direct_msgs.sender_id = ?
                      and t_direct_msgs.receiver_id = ?
                      and t_direct_msgs.workspace_id = ?",
                      session[:muser_id], session[:diruser_id], session[:workspace_id])
        
        TDirectMsg.where(:receiver_id=>session[:muser_id], :sender_id=>session[:diruser_id]).update(:unread=>0)
        #redirect-back(fallback_location: fallback_location)
        list
    end

    def dirmsgsend
        @dir_msg = TDirectMsg.new
        @dir_msg.sender_id = session[:muser_id]
        @dir_msg.receiver_id = session[:diruser_id]
        @dir_msg.workspace_id = session[:workspace_id]
        @dir_msg.message = params[:dirmsg][:msg]
        @dir_msg.unread = 1
        @dir_msg.save
        @dir_msg.reload

    end

    
    def memberlist
    end

    def memberlist1
        list
        channel_memberlist
    end

    def addmember
        list
        channel_memberlist
        exist
    end
    def add
        user_id = params[:user_id]
        @add = MChannel.new(:id=>7, :user_id=>user_id, :workspace_id=>session[:workspace_id], :channel_name=>"Channel7", :status=>1)
        @add.save
        redirect_to addmember_path
    end
    def remove
        member_id=params[:user_id]
        MChannel.where(:id=>7, :user_id=>member_id).delete_all
        flash[:success] = "User deleted"
        redirect_to memberlist1_path
    end
    def admin
        admin_id=params[:user_id]
        MWorkspace.where(:id=>session[:workspace_id],:user_id=>admin_id).update_all(:admin=>admin_id)
        flash[:success] = "Admin Changed"
        redirect_to managemember_path
    end

    def managemember
        list
        @admin=MWorkspace.select("user_id").joins("join m_users on m_users.id=m_workspaces.user_id").
                where("m_workspaces.admin=1 and m_workspaces.id=?",session[:workspace_id])
    end

    def welcome
    end

    def workspacecreate
    end

    def searchworkspace  
    end

    private  
    
    def list 
        @muser=MUser.select("m_users.id, m_users.user_name").joins("join m_workspaces on m_users.id=m_workspaces.user_id ").
                where("m_workspaces.id=?",session[:workspace_id])

        @mchannel=MChannel.select("id,channel_name,status").
                where("workspace_id=? and user_id=?",session[:workspace_id], session[:muser_id])
        
        @dir_count=TDirectMsg.select("sum(unread) as count, m_users.user_name").
                    joins("join m_users on m_users.id=t_direct_msgs.sender_id").
                    where("t_direct_msgs.unread=1 and t_direct_msgs.workspace_id=?
                     and t_direct_msgs.receiver_id=?", session[:workspace_id], session[:muser_id]).
                     group("t_direct_msgs.sender_id")
                     
        @channel_count=TChannelUnreadMsg.select("sum(unread)as count,t_channel_msgs.channel_id").
                        joins("join t_channel_msgs on t_channel_msgs.id=t_channel_unread_msgs.channel_msg_id").
                        where("t_channel_unread_msgs.unread=1 and t_channel_unread_msgs.unread_user_id=?", session[:muser_id]).
                        group("t_channel_msgs.channel_id")
    end

    def channel_memberlist
        #@member_list = MChannel.find_by_sql("select m_users.id as userid, m_users.user_name
        #from m_channels,m_users where m_channels.id=8 and m_users.id = m_channels.user_id")

        @member_list = MChannel.select("m_users.id as userid, m_users.user_name").
        joins("join m_users on m_users.id = m_channels.user_id").
        where("m_channels.id=?",session[:channel_id]) 
    end

    def exist
        @exist=MChannel.select("user_id").
        where("m_channels.id = ? and workspace_id=?", session[:channel_id], session[:workspace_id])
        
    end

    

end
