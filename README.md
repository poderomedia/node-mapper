Node Mapper
===========
A easy to use tool that allows you to build simple visualizations of networks to publish or embed them in your website, without coding, in just a few minutes. NodeMapper is currently in early proof of concept version. In order to improve it and make it useful, we are looking for journalists, designers, developers, academics, civic advocates, newsrooms and organizations interested in testing NodeMapper with real data. If you want to join the alpha tester group, [add your contact info here](https://docs.google.com/a/poderopedia.com/forms/d/1MEuCVvYZUcj2Isxq1IVVLg1oX_LD0F6vistF_s48HrQ/viewform).

Index
========================

* [What is this?](#what-is-this)
* [Assumptions](#assumptions)
* [How can you use it?](#how-can-you-use-it)
* [How to run NodeMapper](#how-to-run-nodemapper)
* [How to contribute](#how-to-contribute)
* [Credits](#Credits)


What is this?
-------------

NodeMapper is a easy network visualization builder using data from a Google Spreadsheet template. It allows you to build simple visualizations of networks to publish or embed them in your website, without coding, in just a few minutes. 
The goal of NodeMapper is to expand and democratize the use of data to do network visualizations for storytelling by people and organizations that don`t have access to programmers, opening new possibilities for anyone interested in creating and publishing visualizations of connections, in a fast and simple way. For more information on the project and how to contribute, please see Roadmap, features and user research.
NodeMapper is a free open source software [free open source software]( vvvvvv) by Poderomedia, developed by Kevin Hu, Manuel Aristarán and Miguel Paz. You can fork it and deploy it with your own modifications. Please see the [License](URL URL) file for details.  

Assumptions
-----------

What is the tool for and what is NOT for (some end user assumptions):
* You know what you want to show as a network visualization.
* You want to publish a network visualization, not analyze it.
* You have a story to tell and including a network visualization can give your story more depth and visual context.
* It`s designed for small network graphs (20 to 30 nodes average, around 100 nodes max. for clarity), not for big hairballs
It should help people show and tell relevant relations giving nodes and edges (entities and connections) weight and as much context as possible. Not give 2 very different relations the same weight. For example: conspiracy theorist believe that if you are member of the board of X, then you are part of a global secret ruling group lead by Y :). Providing good examples and guidelines can help with user behaviour.
* It should help people become “network visualization” savvy to learn the basic concepts to grow from then to more complex projects.

How can you use it?
---------------

* Open the Spreadsheet template https://docs.google.com/spreadsheets/d/1e5pk9DpQBtQayUcSpSAujUyKpJOwwGgWUps5nE95ZHU/edit#gid=695733526. This template has 3 pages: 
inser image here
1. Data page: in the first column you add and ID (1, 2, 3 or A, B, C... etc.), the second column you add the Name of the entity (person, place, organization, animal, etc.) and in the third column you add the type of entity (can be a very strict description, such as: person, company, institution... or very flexible description: offshore company, proxy, drug lord, unicorn, Scientology rind leader, etc). 
In this example template we just use Names of People and Organizations and Person, Company and Institution for type of entity as you can see here: 
2. Nodes: PENDING
3. Connections: PENDING
* Add data into a spreadsheet template
* You publish the spreadsheet
* You paste the url it in the url field 
* You load data, choose settings, save the network visualization
* Copy the url of the network visualization or copy the embed code
* Paste the embed code in your website or share the url with others

How to run Node Mapper
--------------------

Build Process

1. Run `npm install` to install development dependencies

2. Run `gulp` (if you have gulp installed globally) else run `./node_modules/.bin/gulp`
 
How to contribute
--------------------

Want to help us make NodeMapper awesome? Great! Please open and [issue]( URL URL URL) for code, feature ideas, bugs, etc. 

Credits
--------------------

Kevin Hu
Manuel Aristarán
Miguel Paz
Poderomedia would like to give a special thank you to Kevin and Manuel for contributing their time and enthusiasm to develop the first proof of concept of NodeMapper. 
Acknowledgments go as well for their help and feedback to César Hidalgo (director of the MacroConnections Group at MIT MediaLab), Ethan Zuckerman (director of the Civic Media Group at MIT MediaLab), the 2015 Nieman fellows and the Berkman Center for Internet and Society fellows of 2015.
