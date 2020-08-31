#include <iostream>
#include <sstream>

using namespace std;

string sanitize(string &input) {
    ostringstream os;

    for (char c : input) {
        switch(c) {
            case '&':
                os << "&amp;";
                break;
            case '<':
                os << "&lt;";
                break;
            case '>':
                os << "&gt;";
                break;
            default:
                os << c;
        }
    }

    return os.str();
}

int main(int argc, char *argv[]) {
    string input = (argc == 2) ? argv[1] : "<p>yes & no</p>";

    cout << input << " -> " << sanitize(input) << endl;
    
    return 0;
}
