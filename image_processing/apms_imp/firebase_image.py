import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
from datetime import datetime

cred = credentials.Certificate('./keys/serviceAccountKey.json')
firebase_admin.initialize_app(cred, {
    'storageBucket': 'apms-48bd5.appspot.com'
})

bucket = storage.bucket()


def uploadImage(img_name, img_path):
    now = datetime.now()
    img_name = now.strftime("%d-%m-%Y/")+img_name
    blob = bucket.blob(img_name)
    blob.upload_from_filename(img_path)
    blob.make_public()
    print(blob.public_url)
    return blob.public_url


#if __name__ == "__main__":
    uploadImage('69x-1234','capture_51H-14532.png')