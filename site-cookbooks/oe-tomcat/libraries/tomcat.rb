#
# Cookbook Name:: oe-tomcat
# Library:: tomcat
#
# Author:: Emiliano Castagnari (<ecastag@gmail.com>)
#
# Copyleft 2014, Emiliano Castagnari
#
# Modify redistribute, enjoy
#

class Chef::Recipe::Tomcat

  def self.encrypted?(obj = nil)
    case obj.class.to_s
      when 'Hash'
        obj.each { |i,k| return true if k.include?('encrypted_data') }
    end
    return false
  end

  def self.databag(name = nil)
    return nil if name.nil?
    Chef::DataBag.load(name).to_hash()
  end


  def self.databag_item(dbg_name = nil, dbg_item = nil, encrypted = true)
    return nil unless dbg_name and dbg_item
    
    item = Chef::DataBagItem.load(dbg_name, dbg_item).to_hash()
    if self.encrypted?(item) and encrypted
      item = Chef::EncryptedDataBagItem.load(dbg_name, dbg_item).to_hash()
    end
    
    return item
  end

  def self.databag_items(dbg_name = nil, encrypted = true)
    return nil unless dbg_name
    
    items = Hash.new
    
    dbg_items = self.databag(dbg_name)
    dbg_items.keys().each { |k|
      
      i = Chef::DataBagItem.load(dbg_name, k).to_hash()
      if self.encrypted?(i) and encrypted
        i = Chef::EncryptedDataBagItem.load(dbg_name, k).to_hash()
      elsif encrypted
        next
      end
      items[i['id']] = i
    }
    
    return items
  end


  def self.users(databag_name = nil, user_list = nil, encrypted = true)
    users = self.databag_items(databag_name, encrypted)
    
    return users if user_list.nil?
    
    return users.select { |u,data| 
      user_list.include?(u)
    } 
  end
  
  def self.roles(databag_name = nil, encrypted = true)
    roles = self.databag_items(databag_name, encrypted)
    
    return roles.values.collect { |r| r['roles'] }.flatten.uniq
  end

end

