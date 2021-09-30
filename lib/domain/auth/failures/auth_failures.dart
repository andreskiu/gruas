// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_base/domain/core/error_content.dart';
// import 'package:flutter_base/infrastructure/core/failures/server_failures.dart';

// class AuthFailure extends Failure<AuthUseCaseProblems, AuthFieldProblems>
//     with EquatableMixin {
//   final AuthFields? field;
//   final AuthUseCases? useCase;
//   final ServiceFailure? serviceFailure;
//   @override
//   Problem<AuthUseCaseProblems, AuthFieldProblems> problem;

//   AuthFailure._({
//     required this.problem,
//     this.field,
//     this.useCase,
//     this.serviceFailure,
//   }) : super(
//           problem: problem,
//         );

//   @override
//   List<Object?> get props => [
//         field,
//         useCase,
//         problem,
//       ];

//   factory AuthFailure.usecase(AuthUseCaseProblems error, AuthUseCases useCase) {
//     return AuthFailure._(
//       useCase: useCase,
//       problem: Problem(
//         type: ProblemTypes.Field,
//         error: Left(error),
//       ),
//     );
//   }

//   factory AuthFailure.field(AuthFieldProblems error, AuthFields field) {
//     return AuthFailure._(
//       field: field,
//       problem: Problem(
//         type: ProblemTypes.Field,
//         error: Right(error),
//       ),
//     );
//   }

//   factory AuthFailure.server(
//     ServiceFailure failure,
//     AuthUseCases useCase,
//   ) {
//     // aqui deberiamos mapear el codigo de error con el error correspondiente.
//     return AuthFailure._(
//       problem: Problem(
//         type: ProblemTypes.UseCase,
//         error: Left(AuthUseCaseProblems.ServerError),
//       ),
//       useCase: useCase,
//       serviceFailure: failure,
//     );
//   }
//   @override
//   ErrorContent getError() {
//     String _msg = "";
//     late AuthUseCaseProblems _useCaseError;
//     late AuthFieldProblems _fieldError;

//     problem.error.fold((useCaseError) {
//       _useCaseError = useCaseError;
//     }, (fieldError) {
//       _fieldError = fieldError;
//     });

//     const _fieldBase = "auth.fields.";
//     const _useCaseBase = "auth.";

//     switch (problem.type) {
//       case ProblemTypes.UseCase:
//         ServiceFailureType? serviceProblem = serviceFailure?.type;

//         if (serviceProblem != ServiceFailureType.FeatureFailure) {
//           return serviceFailure!.getError();
//         }

//         switch (useCase!) {
//           case AuthUseCases.Login:
//             //TODO switch values to resolve diferent errors. create a class to convert error numbers into failures.
//             _msg = _useCaseBase + "login.errors.invalid_credentials";
//             break;
//           case AuthUseCases.Logout:
//             // should not happen
//             _msg = _useCaseBase + "logout.errors.not_found";
//             break;
//           case AuthUseCases.getLoggedUser:
//             switch (_useCaseError) {
//               case AuthUseCaseProblems.NotFound:
//                 _msg = _useCaseBase + "get_user_logged_in.errors.not_found";
//                 break;
//               default:
//                 break;
//             }
//             break;
//           case AuthUseCases.getUserRemembered:
//             _msg = "";
//             break;
//         }
//         break;
//       case ProblemTypes.Field:
//         switch (field) {
//           case AuthFields.Password:
//             switch (_fieldError) {
//               case AuthFieldProblems.Empty:
//                 _msg = _fieldBase + "password.errors.empty";
//                 break;
//               case AuthFieldProblems.InvalidValue:
//                 _msg = _fieldBase + "password.errors.invalid";
//                 break;
//               case AuthFieldProblems.TooShort:
//                 _msg = _fieldBase + "password.errors.minimumCharacters";
//                 break;
//               case AuthFieldProblems.WithoutUpperCase:
//                 _msg = _fieldBase + "password.errors.uppercaseCharacter";
//                 break;
//               case AuthFieldProblems.WithoutLowerCase:
//                 _msg = _fieldBase + "password.errors.lowercaseCharacter";
//                 break;
//               case AuthFieldProblems.WithoutNumber:
//                 _msg = _fieldBase + "password.errors.minimumNumbers";
//                 break;
//               case AuthFieldProblems.WithoutASymbol:
//                 _msg = _fieldBase + "password.errors.containSymbol";
//                 break;
//               case AuthFieldProblems.None:
//                 break;
//             }
//             break;

//           default:
//             break;
//         }
//         break;
//     }
//     return ErrorContent(message: _msg);
//   }
// }

// enum AuthFields { Password }
// enum AuthUseCases { Login, Logout, getLoggedUser, getUserRemembered }

// enum AuthUseCaseProblems {
//   InvalidParams,
//   InvalidCredentials,
//   ServerError,
//   NotFound,
// }
// enum AuthFieldProblems {
//   None,
//   Empty,
//   InvalidValue,
//   TooShort,
//   WithoutUpperCase,
//   WithoutLowerCase,
//   WithoutNumber,
//   WithoutASymbol
// }
