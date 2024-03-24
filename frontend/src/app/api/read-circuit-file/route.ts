import fs from 'fs/promises';
import path from 'path';

export async function GET(request: Request) {
  
  try {
    const { searchParams } = new URL(request.url)
    const filename = searchParams.get('filename')

    if (!filename) {
      return new Response('Filename parameter is required', {
        status: 400
      })
    }

    const projectRoot = process.cwd();
    const filePath = path.join(projectRoot, './circuits', filename);
    console.log(filePath);
    const data = await fs.readFile(filePath, 'utf-8');
    return new Response(data)
  } catch (error) {
    return new Response(`Error reading file: ${(error as Error).message}`, {
      status: 400,
    })
  }
}