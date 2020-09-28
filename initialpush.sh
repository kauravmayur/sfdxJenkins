#!/bin/bash
sfdx force:package:install -p 04t3o000000xFLqAAM -w 10;
sfdx force:source:deploy -m Settings:Security; 
sfdx force:source:push -f;
sfdx force:user:permset:assign --permsetname "Audit_Field_Permissions"