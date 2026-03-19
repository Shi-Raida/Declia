import '../../domain/entities/client.dart';
import '../../domain/entities/client_list_query.dart';

typedef GetClientParams = ({String id});
typedef SaveClientParams = ({Client client});
typedef CreateClientParams = ({Client client});
typedef UpdateClientParams = ({Client client});
typedef DeleteClientParams = ({String id});
typedef SearchClientsParams = ({String query});
typedef FetchClientsParams = ({ClientListQuery query});
