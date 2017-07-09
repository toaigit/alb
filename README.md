#  This is to create Application Load Balance   
    - including stickiness, rule to route to differrent targets  
      ssl cert  
   NOTEs:  
      You can set target groups in ASG.  The running instances in the  
      ASG will be automatically register in target group (and de-register  
      when the instance is terminated).  
   To create a Classic LB,
      vpc_id, protocal (LBport/Protocol, InstancePort/Protocol
      subnets, SGgroups, XZone-Enabled, InstanceID/optional, TAGs
      Stickiness is defined at Port Configuration.
   TO create a Application LB
      Define Listener protocol/Port,  Zones
      SecurityGroups, routing target group/Protocol/Port, Health checki,
      Register Targets (instance) option, config routeing, Regiser instance is
      option.
