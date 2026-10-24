// Connexion à la base Supabase, la même que l'annuaire Annubus.
// Ces deux valeurs se trouvent dans Supabase > Project Settings > API.
// La clé « anon / publishable » est faite pour être visible : ce sont les règles d'accès
// de la base (réservée aux membres de l'annuaire) qui protègent les données, pas cette clé.
// Ne JAMAIS mettre ici la clé « service_role ».
window.DOCUBUS_CONFIG = {
  supabaseUrl: "https://zsgekjidtzwypjssglbx.supabase.co",
  supabaseAnonKey: "sb_publishable_H-6I3DxUjDAq8H03OgxusA_9C0DB9HS",
  contactAcces: "un administrateur de l'annuaire"   // qui contacter pour obtenir l'accès
};
