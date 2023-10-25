// const BASE_URL = 'http://20.204.160.32:7443/api/v1';   //prod
// ignore_for_file: constant_identifier_names

const BASE_URL = 'https://safetyapi.mahindralogistics.com/api/v1'; //prod-url
// const BASE_URL = 'https://safety1api.mahindralogistics.com/api/v1';

// const BASE_URL = 'http://20.235.121.167:7443/api/v1'; //uat
// const BASE_URL = 'http://10.72.24.125:7443/api/v1'; //nikhil

const IOS_APP_VERSION = '1.0.3'; //current live version-1.0.3

// const GET_LOCATIONS = "/user/getLocations";
const GET_LOCATIONS = "/user/getDepartment";
const UPLOAD_IMAGES = "/user/uploadImage";

const GET_OTP = "/user/getOtp";
const LOGIN_USER = "/user/loginUser";

const GET_USER_TICKETS_LIST = "/user/getAllTicketsList";
const GET_ADMIN_TICKETS_COUNT = "/admin/getAllTicketCount";
const GET_NOC_TICKETS_COUNT = "/admin/getNatureofOccurenceCount";
const GET_ALL_COMMENTS = "/user/getAllComments";
const DOWNLOAD_TICKET = "/user/downloadTicket?";

const POST_COMMENT = "/user/userComment";
const UPDATE_TICKET_STATUS = "/admin/ticketStatus";

const GET_UPDATE_STATUS_LIST = "/user/getStatusList";

const CREATE_TICKET = "/user/createUserIos";

const GET_ALL_AGENTS_LIST = "/user/getAgents";
const SWAP_TICKET_TO_OTHER = "/admin/changeTicketLocation";

const LOG_OUT = "/user/userLogout";

const DOWNTIME_CHECK = "/user/downtime";





 // var url = 'http://20.235.121.167:7443/api/v1/user/uploadImage';
    // var url = 'http://192.168.0.109:7443/api/v1/user/uploadImage';