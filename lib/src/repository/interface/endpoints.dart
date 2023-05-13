abstract class Endpoints<C> {
  C get userCollectionEndpoint;
  C get raceCollectionEndpoint;
  C get collaboratorCollectionEndpoint;
  C get teamCollectionEndpoint;
}