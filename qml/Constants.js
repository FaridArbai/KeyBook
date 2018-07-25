.pragma library

var STD_ELEVATION           =   5;
var TOOLBAR_COLOR           =   "#016479";
var STATUSBAR_COLOR         =   "#014d60";
var TOOLBAR_COLOR_2         =   "#0294bd";
var GRADIENT_TOOLBAR_COLOR  =   "#017379";
var VIBRANT_COLOR           =   "#0097A7";

var TOP_LOGIN_COLOR         =   "#1f5a7a";
var BOTTOM_LOGIN_COLOR      =   "#0f808a";

var BRIGHTER_TOOLBAR_COLOR  =   "#63999E";
var PRESSED_COLOR           =   "#1FFFFFFF";

var FAILURE_COLOR           =   "#FFF2F2";
var SUCESS_COLOR            =   "#F2FFFC";

var LINES_WHITE             =   "#7FFFFFFF";
var GENERAL_TEXT_WHITE      =   "#AFFFFFFF"
var RELEVANT_TEXT_WHITE     =   "#CFFFFFFF";
var BUTTON_WHITE            =   "#1FFFFFFF";
var TRANSPARENT             =   "#00FFFFFF";

var MIN_USERNAME_LENGTH     =   3;
var MAX_USERNAME_LENGTH     =   14;
var MIN_PASSWORD_LENGTH     =   6;
var MAX_PASSWORD_LENGTH     =   14;
var MIN_LATCHKEY_LENGTH     =   4;
var MAX_LATCHKEY_LENGTH     =   14;
var USERNAME_REGEX          =   /^[0-9a-zA-Z]+$/;

var TOOLBUTTON_SIZE         =   40;
var SENDBUTTON_SIZE         =   80;

var LOGIN_STATUSBAR_COLOR               =   0X00000000;
var CONTACTS_STATUSBAR_COLOR            =   0xff014d60;
var IMAGEPROCESSING_STATUSBAR_COLOR     =   0xFF000000;

var SIDE_FACTOR         =   (157/2880);
var SPACING_FACTOR      =   (7/180);
var ICON_FACTOR         =   (34/720);



var MENU_COLOR          =   "#F3F3F3";
var MENU_TRANSPARENCY   =   0xFF;
var ZERO_TRANSPARENCY   =   0x00;
var MENU_WIDTH_FACTOR   =   1/2;
var MENU_RADIUS_FACTOR  =   1/32;

var MENUITEM_PIXEL_FACTOR   =   28;
var MENUITEM_HEIGHT_FACTOR  =   3;
var MENUITEM_PRESSED_COLOR  =   "#10888888";

var MENU_BORDERMARGIN_FACTOR    =   1/32;
var MENU_VERTICALPAD_FACTOR     =   1/2;

var MENU_ENABLED_THRESHOLD      =   0.05;
var MENU_TRANSITIONS_DURATION   =   250;

var MENUFONT_COLOR      =   "black";

var BOXBUTTON_PRESSED_COLOR =   "#40888888";


var IMAGEPROCESSING_MASK    =   "#80000000";
var IMAGEPROCESSING_CANVAS_COLOR = "#40FFFFFF";

var DROPSHADOW_COLOR    =   "#42000000";

var ContactPage = {
    CONTACTNAME_COLOR       : "#016479",
    PRESENCE_COLOR          : "#626665",
    LASTMESSAGE_COLOR       : "#626665",
    UNREAD_CONTAINER_COLOR  : "#029cbd",
    UNREAD_TEXT_COLOR       : "#CCFFFFFF",
    SEPARATORS_COLOR        : "#DDDDDD",
};

var ProfilePage = {
    PADDING_COLOR           :   "#F2F2F2",
    ICONS_COLOR             :   "#016479",
    STATUSINDICATOR_COLOR   :   "#016479",
    TEXT_COLOR              :   "#707070",
    TEXTBOX_COLOR           :   "#F9FFFFFF",
    STATUS_MAXCHARS         :   115,
    BUTTONS_BG_TRANSPARENCY :   "40",
};


var WREF = 720;
var HREF = 1080;

var ConversationPage = {
    PERSONAL_MESSAGE_BACKGROUND :   "#E1FFC7",
    CONTACT_MESSAGE_BACKGROUND  :   "#FFFFFF",
    ERROR_MESSAGE_BACKGROUND    :   "#E53935",
    NEW_DAY_BACKGROUND          :   "#D4EAF4",
    SENDBUTTON_COLOR            :   "#0097A7",
    ERROR_MESSAGE               :   "This message couldn't be decrypted, please change this contact's latchkey.",
    SEND_FIELD_MARGIN           :   9/HREF,

    Message : {
        MIN_PAD     :   114/WREF,
        PAD_OUTTER  :   25/WREF,
        PAD_INNER   :   20/WREF,
        RADIUS      :   8/HREF,
        TIME_PAD    :   14/WREF,
        NEW_DAY_VPAD:   26/HREF,
        SEPARATION  :   5/HREF,
        FIRST_OF_GROUP_SEPARATION   :   17/HREF,
        BUBBLE_HEIGHT   :   23/HREF,
        BUBBLE_WIDTH    :   17/HREF,
    }
};

var TextInput = {
    PASSWORD_CHARACTER  :   "•",
    MASK_DELAY          :   250,

    HINT_COLOR          :   "#9e9e9e",
    SEPARATOR_COLOR     :   "#757575",
    TEXT_COLOR          :   "#4d4d4d",
}


















































