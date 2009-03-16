/*=========================================================================

  Program:   CMake - Cross-Platform Makefile Generator
  Module:    $RCSfile$
  Language:  C++
  Date:      $Date$
  Version:   $Revision$

  Copyright (c) 2002 Kitware, Inc., Insight Consortium.  All rights reserved.
  See Copyright.txt or http://www.cmake.org/HTML/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even 
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#include "cmAddTestCommand.h"

#include "cmTestGenerator.h"

#include "cmTest.h"


// cmExecutableCommand
bool cmAddTestCommand
::InitialPass(std::vector<std::string> const& args, cmExecutionStatus &)
{
  // First argument is the name of the test Second argument is the name of
  // the executable to run (a target or external program) Remaining arguments
  // are the arguments to pass to the executable
  if(args.size() < 2 )
    {
    this->SetError("called with incorrect number of arguments");
    return false;
    }

  // Collect the command with arguments.
  std::vector<std::string> command;
  for(std::vector<std::string>::const_iterator it = args.begin() + 1;
      it != args.end(); ++it)
    {
    command.push_back(*it);
    }

  // Create the test but add a generator only the first time it is
  // seen.  This preserves behavior from before test generators.
  cmTest* test = this->Makefile->GetTest(args[0].c_str());
  if(!test)
    {
    test = this->Makefile->CreateTest(args[0].c_str());
    this->Makefile->AddTestGenerator(new cmTestGenerator(test));
    }
  test->SetCommand(command);

  return true;
}
