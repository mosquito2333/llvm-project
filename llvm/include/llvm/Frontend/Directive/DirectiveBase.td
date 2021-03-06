//===-- DirectiveBase.td - Base directive definition file --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This is the base definition file directives and clauses.
//
//===----------------------------------------------------------------------===//


// General information about the directive language.
class DirectiveLanguage {
  // Name of the directive language such as omp or acc.
  string name = ?;

  // The C++ namespace that code of this directive language should be placed
  // into. This namespace is nested in llvm namespace.
  //
  // By default, uses the name of the directive language as the only namespace.
  // To avoid placing in any namespace, use "". To specify nested namespaces,
  // use "::" as the delimiter, e.g., given "A::B", ops will be placed in
  // `namespace A { namespace B { <directives-clauses> } }`.
  string cppNamespace = name;

  // Optional prefix used for the generation of the enumerator in the Directive
  // enum.
  string directivePrefix = "";

  // Optional prefix used for the generation of the enumerator in the Clause
  // enum.
  string clausePrefix = "";

  // Make the enum values available in the namespace. This allows us to
  // write something like Enum_X if we have a `using namespace cppNamespace`.
  bit makeEnumAvailableInNamespace = 0;

  // Generate include and macro to enable LLVM BitmaskEnum.
  bit enableBitmaskEnumInNamespace = 0;
}

// Information about a specific clause.
class Clause<string c> {
  // Name of the clause.
  string name = c;

  // Define an alternative name return in get<LanguageName>ClauseName function.
  string alternativeName = "";

  // Optional class holding value of the clause in clang AST.
  string clangClass = ?;

  // Is clause implicit? If clause is set as implicit, the default kind will
  // be return in get<LanguageName>ClauseKind instead of their own kind.
  bit isImplicit = 0;

  // Set directive used by default when unknown. Function returning the kind
  // of enumeration will use this clause as the default.
  bit isDefault = 0;
}

// Information about a specific directive
class Directive<string d> {
  // Name of the directive. Can be composite directive sepearted by whitespace.
  string name = d;

  // Define an alternative name return in get<LanguageName>DirectiveName
  // function.
  string alternativeName = "";

  // List of allowed clauses for the directive.
  list<Clause> allowedClauses = ?;

  // List of clauses that are allowed to appear only once.
  list<Clause> allowedOnceClauses = ?;

  // List of clauses that are required.
  list<Clause> requiredClauses = ?;

  // Set directive used by default when unknown.
  bit isDefault = 0;
}
