# Sets up dedicated master node.
node.set['elasticsearch']['node']['data'] = false

# Should not be necessary, but just to be explicit.
node.set['elasticsearch']['node']['master'] = true
