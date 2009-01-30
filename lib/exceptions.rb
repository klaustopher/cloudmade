#
# Copyright 2009 CloudMade.
#
# Licensed under the GNU Lesser General Public License, Version 3.0;
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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