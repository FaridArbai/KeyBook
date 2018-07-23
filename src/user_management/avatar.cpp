#include "avatar.h"

const int Avatar::BRIGHTNESS_THRESHOLD = 255/2;

Avatar::Avatar(){
}

Avatar::Avatar(string image_path){
    this->setImagePath(image_path);
    this->computeThemeColor();
}

Avatar::Avatar(string username, string format, string image_bin){
    string image_path = IOManager::getImagePath(username,format);
    IOManager::saveImage(image_path,image_bin);
    this->setImagePath(image_path);

}

Avatar::Avatar(const Avatar& orig){
    this->setImagePath(orig.getImagePath());
    this->setColor(orig.getColor());
}

string Avatar::toString(){
    string code;
    string image_path = this->getImagePath();

    code = image_path;

    return code;
}

string Avatar::getImagePath() const{
    return this->image_path;
}

int Avatar::getColor() const{
    return this->color;
}

void Avatar::setImagePath(string image_path){
    this->image_path = image_path;
}

void Avatar::computeThemeColor(){
    int color = Avatar::extractMedianColor(this->image_path);
    this->setColor(color);
}

void Avatar::setColor(int color){
    this->color = color;
}

string Avatar::getImageFormat(string image_path){
    string format;
    string image_name;
    int pos_slash = 0;
    int last_pos_slash;
    int pos_point;

    while(pos_slash!=string::npos){
        last_pos_slash = pos_slash;
        pos_slash = image_path.find("/",(pos_slash+1));
        if(pos_slash==string::npos){
            pos_slash = image_path.find("\\",(last_pos_slash+1));
        }
    }


    pos_point = image_path.find(".",last_pos_slash);

    format = image_path.substr(pos_point+1);

    return format;
}

string Avatar::getFormat(){
    string image_path = this->getImagePath();
    string format;
    string image_name;
    int pos_slash = 0;
    int last_pos_slash;
    int pos_point;

    while(pos_slash!=string::npos){
        last_pos_slash = pos_slash;
        pos_slash = image_path.find("/",(pos_slash+1));
        if(pos_slash==string::npos){
            pos_slash = image_path.find("\\",(last_pos_slash+1));
        }
    }


    pos_point = image_path.find(".",last_pos_slash);

    format = image_path.substr(pos_point+1);

    return format;
}

string Avatar::getBinary(){
    string image_path = this->getImagePath();
    string image_bin = IOManager::getImageBinary(image_path);

    return image_bin;
}

int Avatar::extractMedianColor(string source){
    qDebug() << "************** EXTRACT IS CALLED ***************" << endl;
    QImage image(QString::fromStdString(source));
    int height;
    int width;
    QColor color;
    vector<int> v_red;
    vector<int> v_green;
    vector<int> v_blue;
    int red;
    int green;
    int blue;
    int final_color;

    if(image.isNull()==false){
        height = (image.height()>64)?(64):(image.height());
        width = image.width();

        for(int y=0; y<height; y++){
            for(int x=0; x<width; x++){
                color = QColor(image.pixel(y,x));
                v_red.push_back(color.red());
                v_green.push_back(color.green());
                v_blue.push_back(color.blue());
            }
        }

        red = calculateMedian(v_red);
        green = calculateMedian(v_green);
        blue = calculateMedian(v_blue);

        QColor rgb = QColor::fromRgb(red,green,blue);
        int brightness_th = 255/2;
        int brightness_level = rgb.value();

        if(brightness_level>brightness_th){
            rgb = QColor::fromHsv(rgb.hue(),rgb.saturation(),brightness_th).toRgb();
        }

        final_color = (rgb.red()<<16) + (rgb.green()<<8) + (rgb.blue()) + 0xFF000000;
    }
    else{
        final_color = 0xFFC0C0C0;
    }

    return final_color;
}

int Avatar::calculateMedian(vector<int>& v){
    int median;
    int size = v.size();

    std::sort(v.begin(),v.end());

    median = v[size/2];

    return median;
}



























































