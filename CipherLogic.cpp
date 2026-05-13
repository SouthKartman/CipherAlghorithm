#include "CipherLogic.h"
#include <cstring>

CipherLogic::CipherLogic(QObject *parent) 
    : QObject(parent)
    , m_alphabetReady(false) {
    memset(cipher_alphabet, 0, sizeof(cipher_alphabet));
    memset(reverse_alphabet, 0, sizeof(reverse_alphabet));
}

void CipherLogic::setKeyword(const QString &keyword) {
    if (m_keyword != keyword) {
        m_keyword = keyword;
        emit keywordChanged();
        m_alphabetReady = false;
        emit alphabetReadyChanged();
    }
}

void CipherLogic::generateAlphabet() {
    if (m_keyword.isEmpty()) {
        emit notification("Введите ключевое слово!", true);
        return;
    }
    
    for (QChar ch : m_keyword) {
        if (!ch.isLetter()) {
            emit notification("Ключевое слово должно содержать только буквы!", true);
            return;
        }
    }
    
    int used[26] = {0};
    int idx = 0;
    QString upperKeyword = m_keyword.toUpper();
    
    for (int i = 0; i < upperKeyword.length(); i++) {
        QChar ch = upperKeyword[i];
        if (ch.isLetter()) {
            int pos = ch.toLatin1() - 'A';
            if (pos >= 0 && pos < 26 && !used[pos]) {
                used[pos] = 1;
                cipher_alphabet[idx++] = ch.toLatin1();
            }
        }
    }
    
    for (char c = 'A'; c <= 'Z'; c++) {
        int pos = c - 'A';
        if (!used[pos]) {
            cipher_alphabet[idx++] = c;
        }
    }
    cipher_alphabet[idx] = '\0';
    
    for (int i = 0; i < 26; i++) {
        int pos = cipher_alphabet[i] - 'A';
        reverse_alphabet[pos] = 'A' + i;
    }
    reverse_alphabet[26] = '\0';
    
    m_alphabetReady = true;
    emit alphabetChanged();
    emit alphabetReadyChanged();
    emit notification("Алфавит успешно сгенерирован!", false);
}

QString CipherLogic::cipherAlphabet() const {
    if (!m_alphabetReady) return "";
    QString result;
    for (int i = 0; i < 26; i++) {
        result += QChar(cipher_alphabet[i]);
        result += " ";
    }
    return result.trimmed();
}

QString CipherLogic::encrypt(const QString &text) {
    if (!m_alphabetReady) {
        emit notification("Сначала сгенерируйте алфавит!", true);
        return QString();
    }
    
    QString result;
    for (int i = 0; i < text.length(); i++) {
        QChar ch = text[i];
        if (ch.isLetter()) {
            bool upper = ch.isUpper();
            char c = ch.toUpper().toLatin1();
            char new_c = cipher_alphabet[c - 'A'];
            result.append(upper ? QChar(new_c) : QChar(new_c).toLower());
        } else {
            result.append(ch);
        }
    }
    return result;
}

QString CipherLogic::decrypt(const QString &text) {
    if (!m_alphabetReady) {
        emit notification("Сначала сгенерируйте алфавит!", true);
        return QString();
    }
    
    QString result;
    for (int i = 0; i < text.length(); i++) {
        QChar ch = text[i];
        if (ch.isLetter()) {
            bool upper = ch.isUpper();
            char c = ch.toUpper().toLatin1();
            char new_c = reverse_alphabet[c - 'A'];
            result.append(upper ? QChar(new_c) : QChar(new_c).toLower());
        } else {
            result.append(ch);
        }
    }
    return result;
}

QString CipherLogic::getOriginalAlphabet() const {
    QString result;
    for (char c = 'A'; c <= 'Z'; c++) {
        result += QChar(c);
        result += " ";
    }
    return result.trimmed();
}