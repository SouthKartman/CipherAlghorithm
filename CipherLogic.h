#ifndef CIPHERLOGIC_H
#define CIPHERLOGIC_H

#include <QObject>
#include <QString>

class CipherLogic : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString keyword READ keyword WRITE setKeyword NOTIFY keywordChanged)
    Q_PROPERTY(QString cipherAlphabet READ cipherAlphabet NOTIFY alphabetChanged)
    Q_PROPERTY(bool alphabetReady READ alphabetReady NOTIFY alphabetReadyChanged)

private:
    static const int ALPHABET_SIZE = 26;
    char cipher_alphabet[27];
    char reverse_alphabet[27];
    QString m_keyword;
    bool m_alphabetReady;

public:
    explicit CipherLogic(QObject *parent = nullptr);
    
    QString keyword() const { return m_keyword; }
    void setKeyword(const QString &keyword);
    
    QString cipherAlphabet() const;
    bool alphabetReady() const { return m_alphabetReady; }
    
    Q_INVOKABLE void generateAlphabet();
    Q_INVOKABLE QString encrypt(const QString &text);
    Q_INVOKABLE QString decrypt(const QString &text);
    Q_INVOKABLE QString getOriginalAlphabet() const;

signals:
    void keywordChanged();
    void alphabetChanged();
    void alphabetReadyChanged();
    void notification(const QString &message, bool isError);
};

#endif // CIPHERLOGIC_H