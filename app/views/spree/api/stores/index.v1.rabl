object false

node(:count) { @stores.size }
node(:total_count) { @stores.size }
child(@stores => :stores) do
  extends 'spree/api/stores/show'
end