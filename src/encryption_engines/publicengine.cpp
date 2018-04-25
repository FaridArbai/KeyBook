#include "publicengine.h"

const char PublicEngine::PUBLIC_KEY[] = "-----BEGIN PUBLIC KEY-----\n"
                            "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA36F1ad/VQcnDRSuh95Lc\n"
                            "xaiaMFz9KSuSDQZTKZV5wq3N2BVMhzbWFZhCexwVbGZNwlOrSLxVAzGQlmT3nRD8\n"
                            "pef2gL90MSyuH9VRF+Wypq2XvKp48CScu6QruzeYkq9GJS/Ow55Ofei8TyKEz27j\n"
                            "r3EdFIBQpQfNAytdOEkDIZQFryZwrtsAQ7D/TAsXbIlpsYPQETnS9FeqFiuyey96\n"
                            "OnfDaiF0LgRaP44FyWPKh9PtTiMDAUVAapSNrK6mFZ29jfBNPKbOgRbS4CnxS6P6\n"
                            "tUZ/O1/sYrEymwgp9EBdx62I4wl5I+uvzbt0Nld2qkETwLyDweenjTdSiz2IlB2L\n"
                            "qwIDAQAB\n"
                            "-----END PUBLIC KEY-----";



bool PublicEngine::verifySignature(const string &payload, const string &signature){
    return true;
}
