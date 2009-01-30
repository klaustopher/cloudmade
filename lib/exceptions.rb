#Raised when API key is not specified in Connection constructor
class APIKeyMissingError < Exception
end

#Raised when object was not found by geocoding service
class ObjectNotFound < Exception
end

#Raised when HTTP code other than 200 returned
class HTTPError < Exception
end

#Raised when specified route couldn't be found
class RouteNotFound < Exception
end

#Raised when geometry is malformed
class GeometryParseError < Exception
end