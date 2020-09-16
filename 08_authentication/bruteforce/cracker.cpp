#include <functional>
#include <iomanip>
#include <iostream>
#include <openssl/evp.h>
#include <openssl/sha.h>
#include <openssl/pkcs7.h>

#define ITERATIONS 2048
// len(key) is 40, but the len is... uhh...
// bitsize = 4 * (len(hex))
#define OUTSIZE 160 // 40 -> 40*4=160 ... 320???

// med A-z tok det 40 sekunder
/* #define START_CHAR 'A' */
/* #define END_CHAR 'z' */

// Med SPACE-tilde tok det 4.5 minutter
#define START_CHAR ' '
#define END_CHAR '~'

using namespace std;

// Mr. Eidheim's code..
std::string hex(const std::string &input) {
  std::stringstream hex_stream;
  hex_stream << std::hex << std::internal << std::setfill('0');
  for (auto &byte : input)
    hex_stream << std::setw(2) << (int)(unsigned char)byte;
  return hex_stream.str();
}

// returning a key of the requested size in bits
// Performs PBKDF2 on pass and salt,
string hashit(const string &pass, const string &salt, const long bitsize) {
    string out;
    // size in bytes!
    const long size = bitsize / 8;
    out.resize(size);
    PKCS5_PBKDF2_HMAC_SHA1(
            pass.data(), pass.size(),
            (const unsigned char *)salt.data(), salt.size(),
            /* ITERATIONS, EVP_sha1(), // I assume SHA1 is the algorithm Eidheim used */
            ITERATIONS,
            size, (unsigned char *)out.data()
    );
    return out;
}

// Complexity: O(k^n) where k 
string findit(function<bool(string)> operation) {
    string test;
    int maxsize = 30;
    int cursize = 1;
    test.resize(maxsize);
    test[0] = START_CHAR;
    while (cursize < maxsize) {
        // test
        if (operation(test))
            return test;
        // go to next permutation
        if (test[cursize-1] < END_CHAR) {
            test[cursize-1]++;
        } else {
            // go backwards
            test[cursize-1] = START_CHAR; // reset current
            bool upper = false;
            for (int i = cursize-2; i >= 0; i--) {
                if (test[i] < END_CHAR) {
                    test[i]++; // next upper permutation
                    upper = true;
                    break;
                } else { // this position is exhausted
                    test[i] = START_CHAR; // reset this position
                }
            }
            if (!upper) {
                test[cursize++] = START_CHAR; // go to next size
                cout << "Going to " << cursize << " chars" << endl;
            }
        }
    }
    return "we failed";
}

int main() {
    const string thekey = "ab29d7b5c589e18b52261ecba1d3a7e7cbf212c6";
    const string thesalt = "Saltet til Ola";
    cout << thekey << endl;
    cout << hex(hashit("QwE", thesalt, OUTSIZE)) << endl;
    const string result = findit([&thekey, &thesalt](string test) {
        return thekey == hex(hashit(test, thesalt, OUTSIZE));
    });
    cout << result << endl;
}
