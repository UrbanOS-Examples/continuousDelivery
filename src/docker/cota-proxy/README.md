# COTA Proxy

Because we don't want to expose anything in the dev environment,
but still need a way to view web applications running in that environment, 
we created this proxy.

This proxy will be deployed in the ALM (Application Life Cycle Management) Network and 
provide visibility to our COTA application via VPC peering.

The container injects enviornment variables into the Nginx config when the container starts.