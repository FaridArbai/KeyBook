#include "date.h"

const string Date::SUNDAY     = "Sun";
const string Date::MONDAY     = "Mon";
const string Date::TUESDAY    = "Tue";
const string Date::WEDNESDAY  = "Wed";
const string Date::THURSDAY   = "Thu";
const string Date::FRIDAY     = "Fri";
const string Date::SATURDAY   = "Sat";
const string Date::ERROR_DAY  = "ERR";

const string Date::FIELDS_SEP  = "-";
const string Date::DATE_SEP    = "/";
const string Date::TIME_SEP    = ":";

Date::Date() : Date(ProtocolMessage::getGenerationDate()){
}

Date::Date(const Date& orig){
    this->setWeekday(orig.getWeekday());
    this->setDay(orig.getDay());
    this->setMonth(orig.getMonth());
    this->setYear(orig.getYear());
    this->setHour(orig.getHour());
    this->setMinute(orig.getMinute());
}


Date::Date(string date){
    int n_weekday;

    n_weekday = stda::stoi(date.substr(0,1));

    int i0, iF;
    int pos_split;

    i0 = 2;
    iF = date.length() - i0;
    string DDMMYY_HHmm = date.substr(i0,iF);

    int pos_split_date_hour = DDMMYY_HHmm.find("-");

    i0 = 0;
    iF = pos_split_date_hour;
    string DDMMYY = DDMMYY_HHmm.substr(i0,iF);

        pos_split = DDMMYY.find("/");

        i0 = 0;
        iF = pos_split;
        string DD = DDMMYY.substr(i0,iF);

        i0 = pos_split + 1;
        iF = DDMMYY.length() - i0;
        string MMYY = DDMMYY.substr(i0,iF);

        pos_split = MMYY.find("/");

        i0 = 0;
        iF = pos_split;
        string MM = MMYY.substr(i0,iF);

        i0 = pos_split + 1;
        iF = MMYY.length() - i0;
        string YY = MMYY.substr(i0,iF);

    i0 = pos_split_date_hour + 1;
    iF = DDMMYY_HHmm.length() - i0;
    string HHmm = DDMMYY_HHmm.substr(i0,iF);

        pos_split = HHmm.find(":");

        i0 = 0;
        iF = pos_split;
        string HH = HHmm.substr(i0,iF);

        i0 = pos_split + 1;
        iF = HHmm.length() - i0;
        string mm = HHmm.substr(i0,iF);

    string weekday = decodeWeekday(n_weekday);
    string day = DD;
    string month = MM;
    string year = YY;
    string hour = HH;
    string minute = mm;

    this->setWeekday(weekday);
    this->setDay(day);
    this->setMonth(month);
    this->setYear(year);
    this->setHour(hour);
    this->setMinute(minute);
}

string Date::toString(){
    string code     = "";
    string year     = this->getYear();
    string month    = this->getMonth();
    string day      = this->getDay();
    string hour     = this->getHour();
    string minute   = this->getMinute();
    string weekday  = this->getWeekday();
    int n_weekday   = encodeWeekday(weekday);

    string n_weekday_str = stda::to_string(n_weekday);



    code += n_weekday_str + FIELDS_SEP;
    code += day + DATE_SEP + month + DATE_SEP + year + FIELDS_SEP;
    code += hour + TIME_SEP + minute;

    return code;
}

int Date::encodeWeekday(string date){
    int code;

    if(date==SUNDAY){
        code = 0;
    }
    else if(date==MONDAY){
        code = 1;
    }
    else if(date==TUESDAY){
        code = 2;
    }
    else if(date==WEDNESDAY){
        code = 3;
    }
    else if(date==THURSDAY){
        code = 4;
    }
    else if(date==FRIDAY){
        code = 5;
    }
    else if(date==SATURDAY){
        code = 6;
    }
    else{
        code = 99;
    }

    return code;
}

string Date::decodeWeekday(int n_weekday){
    string weekday;

    switch(n_weekday){
        case 0 : weekday = SUNDAY; break;
        case 1 : weekday = MONDAY; break;
        case 2 : weekday = TUESDAY; break;
        case 3 : weekday = WEDNESDAY; break;
        case 4 : weekday = THURSDAY; break;
        case 5 : weekday = FRIDAY; break;
        case 6 : weekday = SATURDAY; break;
        default : weekday = ERROR_DAY; break;
    }

    return weekday;
}

string Date::getYear() const{
    return this->year;
}

void Date::setYear(string year){
    this->year = year;
}

string Date::getMonth() const{
    return this->month;
}

void Date::setMonth(string month){
    this->month = month;
}

string Date::getDay() const{
    return this->day;
}

void Date::setDay(string day){
    this->day = day;
}

string Date::getWeekday() const{
    return this->weekday;
}

void Date::setWeekday(string weekday){
    this->weekday = weekday;
}

string Date::getHour() const{
    return this->hour;
}

void Date::setHour(string hour){
    this->hour = hour;
}

string Date::getMinute() const{
    return this->minute;
}

void Date::setMinute(string minute){
    this->minute = minute;
}

string Date::toHumanReadable(){
    string date_str;

    date_str = getDay() + "/" + getMonth() + " at " + getHour() + ":" + getMinute();

    return date_str;
}

int Date::countLeapYears(){
    int years = stda::stoi(this->getYear().c_str());

    int month = stda::stoi(this->getMonth());

    if (month <= 2){
        years--;
    }

    return (years/4) - (years/100) + (years/400);
}


int Date::difference(Date date){
    int month_days[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    long int n1 = stda::stoi(this->getYear())*365 + stda::stoi(this->getDay());

    for(int i=0; i<(stda::stoi(this->getMonth())-1); i++){
        n1 += month_days[i];
    }

    n1 += this->countLeapYears();

    long int n2 = stda::stoi(date.getYear())*365 + stda::stoi(date.getDay());

    for (int i=0; i<(stda::stoi(date.getMonth())-1); i++){
        n2 += month_days[i];
    }

    n2 += date.countLeapYears();

    // return difference between two counts
    return (n2 - n1);
}

int Date::daysFromToday(){
    Date today = Date();
    int days_from_today;

    days_from_today = this->difference(today);

    return days_from_today;
}























