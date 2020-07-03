//
//  AppLanguageViewModel.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

struct AppLanguageViewModel {
    
    private var languageModel: AppLanguageModel
    
    private var arabic: String
    private var german: String
    private var english: String // Default
    private var spanish: String
    private var french: String
    private var italian: String
    private var portuguese: String
    
    init() {
        
        languageModel = AppLanguageModel.init()
        
        arabic = languageModel.languages.arabic.alpha2
        german = languageModel.languages.german.alpha2
        english = languageModel.languages.english.alpha2
        spanish = languageModel.languages.spanish.alpha2
        french = languageModel.languages.french.alpha2
        italian = languageModel.languages.italian.alpha2
        portuguese = languageModel.languages.portuguese.alpha2
        
    }
    
    
    
    // MARK: - Languages
    
    var languageName: String {
        
        switch languageModel.language {
        case arabic: return languageModel.languages.arabic.name
        case german: return languageModel.languages.german.name
        case spanish: return languageModel.languages.spanish.name
        case french: return languageModel.languages.french.name
        case italian: return languageModel.languages.italian.name
        case portuguese: return languageModel.languages.portuguese.name
        default: return languageModel.languages.english.name
        }
        
    }
    
    var languages: [String] {
        var languagesArray: [String] = []
        for index in languageModel.languages.languages {
            languagesArray.append(index.name)
        }
        return languagesArray
    }
    
    var languagesAlpha2: [String] {
        var languagesArray: [String] = []
        for index in languageModel.languages.languages {
            languagesArray.append(index.alpha2)
        }
        return languagesArray
    }
    
    
    
    // MARK: - Dictionaries
    
    private var dictionaries: [(name: String, website: String, icon: UIImage)] {
        
        switch languageModel.language {
        case arabic: return languageModel.dictionaries.arabicDictionaries
        case german: return languageModel.dictionaries.germanDictionaries
        case spanish: return languageModel.dictionaries.spanishDictionaries
        case french: return languageModel.dictionaries.frenchDictionaries
        case italian: return languageModel.dictionaries.italianDictionaries
        case portuguese: return languageModel.dictionaries.portugueseDictionaries
        default: return languageModel.dictionaries.englishDictionaries
        }
        
    }
    
    var dictionariesName: [String] {
        var updatedDictionaries: [String] = []
        for (name, _, _) in dictionaries {
            updatedDictionaries.append(name)
        }
        return updatedDictionaries
    }
    
    var dictionariesWebsite: [String] {
        var updatedDictionaries: [String] = []
        for (_, website, _) in dictionaries {
            updatedDictionaries.append(website)
        }
        return updatedDictionaries
    }
    
    var dictionariesIcon: [UIImage] {
        var updatedDictionaries: [UIImage] = []
        for (_, _, icon) in dictionaries {
            updatedDictionaries.append(icon)
        }
        return updatedDictionaries
    }
    
    
    
    // MARK: - A
    
    var alert: String {
        
        switch languageModel.language {
        case arabic: return "تحذير"
        case german: return "Warnung"
        case spanish, portuguese: return "Alerta"
        case french: return "Alerte"
        case italian: return "Avvertimento"
        default: return "Alert"
        }
        
    }
    
    
    
    // MARK: - C
    
    var cancel: String {
        
        switch languageModel.language {
        case arabic: return "إلغاء"
        case german: return "Abbrechen"
        case spanish: return "Cancelar"
        case french: return "Annuler"
        case italian: return "Annulla"
        case portuguese: return "Cancelar"
        default: return "Cancel"
        }
        
    }
    
    var checkInternetText: String {
        
        switch languageModel.language {
        case arabic: return "تحقق إذا كان جهازك متصل بالإنترنت"
        case german: return "Überprüfe, ob Ihr Gerät mit dem Internet verbunden ist"
        case spanish: return "Comprueba si tu dispositivo está conectado a internet"
        case french: return "Vérifiez si votre appareil est connecté à Internet"
        case italian: return "Controlla se il tuo dispositivo è connesso ad internet"
        case portuguese: return "Verifique se o seu dispositivo está ligado à internet"
        default: return "Check if your device is connected to the internet"
        }
        
    }
    
    var clearAll: String {
        
        switch languageModel.language {
        case arabic: return "مسح سجل التاريخ"
        case german: return "Verlauf löschen"
        case spanish: return "Borrar historial"
        case french: return "Tout Effacer"
        case italian: return "Cancella cronologia"
        case portuguese: return "Eliminar histórico"
        default: return "Clear All"
        }
        
    }
    
    var clearHistoryText: String {
        
        switch languageModel.language {
        case arabic: return "هل تريد بالتأكيد حذف تاريخ البحث بالكامل؟"
        case german: return "Sind Sie sich sicher, dass sie ihren gesamten Verlauf löschen wollen?"
        case spanish: return "¿Estás seguro de que quieres borrar todo tu historial?"
        case french: return "Êtes vous certain de vouloir effacer tout votre historique?"
        case italian: return "Sei sicuro di voler cancellare tutta la tua cronologia?"
        case portuguese: return "Tem a certeza de que pretende eliminar todo o seu histórico?"
        default: return "Are you sure you want to clear all your history?"
        }
        
    }
    
    var close: String {
        
        switch languageModel.language {
        case arabic: return "إخفاء"
        case german: return "Schließen"
        case spanish: return "Cerrar"
        case french: return "Fermer"
        case italian: return "Chiudere"
        case portuguese: return "Fechar"
        default: return "Close"
        }
        
    }
    
    
    
    // MARK: - D
    
    var darkTheme: String {
        
        switch languageModel.language {
        case arabic: return "ألوان داكنة"
        case german: return "Dunkles Thema"
        case spanish: return "Tema Oscuro"
        case french: return "Thème Sombre"
        case italian: return "Tema Scuro"
        case portuguese: return "Tema Escuro"
        default: return "Dark Theme"
        }
        
    }
    
    var dictionary: String {
        
        switch languageModel.language {
        case arabic: return "قاموس"
        case german: return "Wörterbuch"
        case spanish: return "Diccionario"
        case french: return "Dictionnaire"
        case italian: return "Dizionario"
        case portuguese: return "Dicionário"
        default: return "Dictionary"
        }
        
    }
    
    
    
    // MARK: - E
    
    var enterAValidWordText: String {
        
        switch languageModel.language {
        case arabic: return "أدخل كلمة صالحة ليتم تعريفها"
        case german: return "Geben Sie ein gültiges Wort ein, das definiert werden soll"
        case spanish: return "Ingrese una palabra válida para definir"
        case french: return "Entrez un mot valide à définir"
        case italian: return "Inserisci una parola valida da definire"
        case portuguese: return "Insira uma palavra válida para definir"
        default: return "Enter a valid word to define"
        }
        
    }
    
    var error: String {
        
        switch languageModel.language {
        case arabic: return "خطأ"
        case german: return "Fehler"
        case french: return "Erreur"
        case italian: return "Errore"
        case portuguese: return "Erro"
        default: return "Error"
        }
        
    }
    
    
    
    // MARK: - H
    
    var history: String {
        
        switch languageModel.language {
        case arabic: return "سجل التاريخ"
        case german: return "Verlauf"
        case spanish: return "Historial"
        case french: return "Historique"
        case italian: return "Cronologia"
        case portuguese: return "Histórico"
        default: return "History"
        }
        
    }
    
    
    
    // MARK: - I
    
    var itsEmptyInHere: String {
        
        switch languageModel.language {
        case arabic: return "إنّه فارغ هنا!"
        case german: return "Es ist leer hier!"
        case spanish: return "Está vacío aquí!"
        case french: return "C'est vide ici!"
        case italian: return "È vuoto qui!"
        case portuguese: return "Está vazio aqui!"
        default: return "It's empty in here!"
        }
        
    }
    
    
    
    // MARK: - L
    
    var language: String {
        
        switch languageModel.language {
        case arabic: return "اللغة"
        case german: return "Sprache"
        case spanish, portuguese: return "Idioma"
        case italian: return "Lingua"
        default: return "Language"
        }
        
    }
    
    
    
    // MARK: - P
    
    var privacyPolicy: String {
        
        switch languageModel.language {
        case arabic: return "نهج الخصوصية"
        case german: return "Datenschutzrichtlinie"
        case spanish: return "Política de Privacidad"
        case french: return "Engagement de Confidentialité"
        case italian: return "Norme sulla Privacy"
        case portuguese: return "Política de Privacidade"
        default: return "Privacy Policy"
        }
        
    }
    
    var productOfLebanon: String {
        
        switch languageModel.language {
        case arabic: return "Product of Lebanon"
        case german: return "Produkt des Libanon"
        case spanish: return "Producto de Líbano"
        case french: return "Produit du Liban"
        case italian: return "Prodotto del Libano"
        case portuguese: return "Produto do Líbano"
        default: return "Product of Lebanon"
        }
        
    }
    
    
    
    // MARK: - S
    
    var settings: String {
        
        switch languageModel.language {
            case arabic: return "الإعدادات"
            case german: return "Einstellungen"
            case spanish: return "Ajustes"
            case french: return "Paramètres"
            case italian: return "Impostazioni"
            case portuguese: return "Definições"
            default: return "Settings"
        }
        
    }
    
    var shareDefinitionText1: String {
        
        switch languageModel.language {
        case arabic: return "هنا تعريف"
        case german: return "Hier ist die Definition von"
        case spanish: return "Aquí está la definición de"
        case french: return "Voici la définition de"
        case italian: return "Ecco la definizione di"
        case portuguese: return "Aqui está a definição de"
        default: return "Here is the definition of"
        }
        
    }
    
    var shareDefinitionText2: String {
        
        switch languageModel.language {
        case arabic: return "المتوجّه إليكم من التطبيق ?Huh"
        case german: return "dank der Huh? Wörterbuch–App"
        case spanish: return "gracias a la aplicación Huh?"
        case french: return "grâce à l’application Huh?"
        case italian: return "grazie all'applicazione Huh?"
        case portuguese: return "graças à aplicação Huh?"
        default: return "brought to you by the Huh? Dictionary App"
        }
        
    }
    
    
    
    // MARK: - V
    
    var versionText: String {
        
        switch languageModel.language {
            case arabic: return "الإصدار \(Bundle.main.versionNumber ?? "A.a")"
            case spanish: return "Versión \(Bundle.main.versionNumber ?? "A.a")"
            case italian: return "Versione \(Bundle.main.versionNumber ?? "A.a")"
            case portuguese: return "Versão \(Bundle.main.versionNumber ?? "A.a")"
            default: return "Version \(Bundle.main.versionNumber ?? "A.a")"
        }
        
    }
    
}
