import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data_objects/project.dart';

import '../elements/project_card.dart';

import '../layout/responsive_scaffold.dart';

class ProjectsPage extends StatefulWidget {
  ProjectsPage({
    Key key,
    this.projectCards,
  }) : super(key: key);

  final List<ProjectCard> projectCards;

  @override
  _ProjectsPageState createState() => new _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {

  var devProjects = <ProjectCard>[
    new ProjectCard(name: 'Project 1', height: 300.0, width: 200.0,),
    new ProjectCard(name: 'Project 2', height: 300.0, width: 200.0,),
    new ProjectCard(name: 'Project 3', height: 200.0, width: 200.0,),
    new ProjectCard(name: 'Project 1', height: 300.0, width: 100.0,),
    new ProjectCard(name: 'Project 2', height: 300.0, width: 200.0,),
    new ProjectCard(name: 'Project 3', height: 200.0, width: 200.0,)
  ];

  @override
  Widget build(BuildContext context) {
    return new ResponsiveScaffold(
      name: "Projects",
      body: new GridView.extent(
  primary: false,
  padding: const EdgeInsets.all(20.0),
  mainAxisSpacing: 24.0,
  crossAxisSpacing: 24.0,
  maxCrossAxisExtent: 300.0,
  children: devProjects
)
        // child: new Wrap(
        //   spacing: 24.0, // gap between adjacent chips
        //   runSpacing: 24.0, // gap between lines
        //   children: devProjects,
        // ),
    );
  }
}