Useful stuff for the force.com platform
=======================================

The Salesforce Security Review team require that managed custom applications include explicit validation of CRUD and FLS (Field Level Security).  

It came as a surprise to many that the Force.com platform does not do this.

This GitHub repository contains a single Class, ValidateAccessSupport, that can be used in a trigger-based solution to implement CRUD and FLS validation without having to change any existing code.


The repository contains a example triggers, for the standard Account and Opportunity objects, as well as an example test method, assuming you have implemented the example triggers.

The triggers are simple, and can be implemented on any object for which you want to enforce CRUD and FLS validation.  

Let me know how this works for you, or if you have any questions.

Alan Davies
Pinkelk Consulting, Inc.
alan@pinkelk.com
+1 818 415 0211
https://pinkelk.com
