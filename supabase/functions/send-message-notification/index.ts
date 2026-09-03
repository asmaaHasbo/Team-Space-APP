import { createClient } from "jsr:@supabase/supabase-js@2";
import { JWT } from "npm:google-auth-library@9";

Deno.serve(async (req) => {
  const payload = await req.json();
  const message = payload.record;

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // مين المفروض يتبلّغ؟ القاعدة كلها في الداتابيز، مش هنا.
  const { data: targets, error } = await supabase.rpc(
    "get_notification_targets",
    {
      p_chat_id: message.chat_id,
      p_sender_id: message.created_by,      
      p_sent_at: message.created_at
    },
  );

  if (error) {
    console.error("rpc failed:", error);
    return new Response("rpc failed", { status: 500 });
  }

  // محدش محتاج إشعار — الكل قاعد فاتح الشات، أو مفيش أجهزة مسجّلة.
  if (!targets || targets.length === 0) {
    return new Response("no targets", { status: 200 });
  }

  const accessToken = await getAccessToken();
  const projectId = JSON.parse(
    Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!,
  ).project_id;

  const senderName = targets[0].sender_name ?? "رسالة جديدة";

  // كل جهاز بيتبعتله لوحده — واحد بيفشل مايوقفش الباقي.
  await Promise.all(
    targets.map((target) =>
      fetch(
        `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            message: {
              token: target.token,
              notification: {
                title: senderName,
                body: message.message_content,
              },
              data: {
                chat_id: message.chat_id,
              },
            },
          }),
        },
      )
    ),
  );

  return new Response("ok", { status: 200 });
});

/// المفتاح السري مش بيتبعت لجوجل — بيتوقّع بيه طلب بيرجّع تصريح مؤقت.
async function getAccessToken(): Promise<string> {
  const credentials = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!);

  const jwtClient = new JWT({
    email: credentials.client_email,
    key: credentials.private_key,
    scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
  });

  const tokens = await jwtClient.authorize();
  return tokens.access_token!;
}